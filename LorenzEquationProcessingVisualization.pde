float LorenzConstantP = 10.0;
float LorenzConstantR = 28;
float LorenzConstantB = 8.0/3.0;
float TimeConstant = 1.0; //[sec]
int LorenzEquationSize = 3;

LorenzEquation[] Lorenz_equation_array;
int[][] color_map;

RingBufferFloat[] Lorenz_x_buffer;
RingBufferFloat[] Lorenz_y_buffer;
RingBufferFloat[] Lorenz_z_buffer;
int LorenzBufferSize = 200;

float step_time = 0.01; //[sec]
int frame_rate = int(1/step_time);

float Display3D_ScaleX = 8;
float Display3D_ScaleY = 8;
float Display3D_ScaleZ = -8;
float Display3D_ShiftX = 250;
float Display3D_ShiftY = 0;
float Display3D_ShiftZ = 150;


float Display2D_ScaleTime = 2;
float Display2D_ScaleX = -2;
float Display2D_ScaleY = -2;
float Display2D_ScaleZ = -2;
float Display2D_ShiftTime = 100;
float Display2D_ShiftX = 150;
float Display2D_ShiftY = 400;
float Display2D_ShiftZ = 750;

int mouseX_dragged = 0;
int mouseY_dragged = 0;
int mouseX_pressed = 0;
int mouseY_pressed = 0;

int window_size_x = 1200;
int window_size_y = 800;
void setup() {
  size( 1200, 800, P3D );
  frameRate(frame_rate);


  Lorenz_equation_array = new LorenzEquation[LorenzEquationSize];
  Lorenz_x_buffer = new RingBufferFloat[LorenzEquationSize];
  Lorenz_y_buffer = new RingBufferFloat[LorenzEquationSize];
  Lorenz_z_buffer = new RingBufferFloat[LorenzEquationSize];
  color_map = new int[LorenzEquationSize][];

  //sine = new SineWave[NeuronSize];
  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) {

    Lorenz_equation_array[Lorenz_index] = new LorenzEquation();
    Lorenz_equation_array[Lorenz_index].set_parameters( step_time, 
      TimeConstant, 
      LorenzConstantP, 
      LorenzConstantR, 
      LorenzConstantB );
    Lorenz_equation_array[Lorenz_index].set_initial_states( random(-1, 1), random(-1, 1), random(-1, 1) );
    Lorenz_equation_array[Lorenz_index].reset();
    color_map[Lorenz_index] = new int[3];
    int[] color_rgb = HSVtoRGB(int(float(Lorenz_index)/float(LorenzEquationSize)*360), 255, 255);
    //println(Lorenz_index, " ", LorenzEquationSize, float(Lorenz_index)/float(LorenzEquationSize),
    //int(float(Lorenz_index)/float(LorenzEquationSize)*360), " ",
    //println(color_rgb[0], " ", color_rgb[1], " ", color_rgb[2]);
    color_map[Lorenz_index][0] = color_rgb[0];
    color_map[Lorenz_index][1] = color_rgb[1];
    color_map[Lorenz_index][2] = color_rgb[2];

    Lorenz_x_buffer[Lorenz_index] = new RingBufferFloat( LorenzBufferSize, 
      Lorenz_equation_array[Lorenz_index].get_x() );
    Lorenz_y_buffer[Lorenz_index] = new RingBufferFloat( LorenzBufferSize, 
      Lorenz_equation_array[Lorenz_index].get_y() );
    Lorenz_z_buffer[Lorenz_index] = new RingBufferFloat( LorenzBufferSize, 
      Lorenz_equation_array[Lorenz_index].get_z() );
    for ( int data_index = 0; data_index < LorenzBufferSize; data_index++ ) {
      Lorenz_x_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_x() );
      Lorenz_y_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_y() );
      Lorenz_z_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_z() );
    }
  }
}

void draw() {
  background(0);
  noStroke();
  colorMode(RGB, 100);
  //background(100,0,100);
  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) {
    Lorenz_equation_array[Lorenz_index].update();
    //println("index: ", Lorenz_index, 
    //        ", x: ", Lorenz_equation_array[Lorenz_index].get_x(),
    //        ", y: ", Lorenz_equation_array[Lorenz_index].get_y(),
    //        ", z: ", Lorenz_equation_array[Lorenz_index].get_z() );
  }
  stroke( 255, 255, 255 );
  fill(  255, 255, 255 );
  textSize(20);
  text("X-Y-Z", 800, 30);
  text("Time-X", Display2D_ShiftTime-80, Display2D_ShiftX);
  text("Time-Y", Display2D_ShiftTime-80, Display2D_ShiftY);
  text("Time-Z", Display2D_ShiftTime-80, Display2D_ShiftZ);
  text("X-Y-Z", 800, 30);

  text("Lorenz Equation", 510, 30);
  text("tau dx/dt = - px + py", 510, 60);
  text("tau dy/dt = - xz + rx - y", 510, 80);
  text("tau dz/dt =   xy - bz", 510, 100);
  text("tau=", 510, 130);
  text(TimeConstant, 550, 130);
  text("p=", 510, 150);
  text(LorenzConstantP, 550, 150);
  text("r=", 510, 170);
  text(LorenzConstantR, 550, 170);
  text("b=", 510, 190);
  text(LorenzConstantB, 550, 190);
  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) {
    //Plot Time-X
    for ( int data_index = 0; data_index < LorenzBufferSize - 1; data_index++ ) {
      stroke( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      fill( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_x_buffer[Lorenz_index].get_data( data_index )*Display2D_ScaleX+Display2D_ShiftX, 
        (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_x_buffer[Lorenz_index].get_data( data_index + 1 )*Display2D_ScaleX+Display2D_ShiftX );
    }
    fill( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    stroke( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    line( (LorenzBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_x_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display2D_ScaleX+Display2D_ShiftX, 
      LorenzBufferSize*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_equation_array[Lorenz_index].get_x()*Display2D_ScaleX+Display2D_ShiftX );


    //Plot Time-Y
    for ( int data_index = 0; data_index < LorenzBufferSize - 1; data_index++ ) {

      fill( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      stroke( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_y_buffer[Lorenz_index].get_data( data_index )*Display2D_ScaleY+Display2D_ShiftY, 
        (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_y_buffer[Lorenz_index].get_data( data_index + 1 )*Display2D_ScaleY+Display2D_ShiftY );
    }

    fill( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    stroke( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    line( (LorenzBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_y_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display2D_ScaleY+Display2D_ShiftY, 
      LorenzBufferSize*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_equation_array[Lorenz_index].get_y()*Display2D_ScaleY+Display2D_ShiftY );

    //Plot Time-Z

    for ( int data_index = 0; data_index < LorenzBufferSize - 1; data_index++ ) {
      fill( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      stroke( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_z_buffer[Lorenz_index].get_data( data_index )*Display2D_ScaleZ+Display2D_ShiftZ, 
        (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
        Lorenz_z_buffer[Lorenz_index].get_data( data_index + 1 )*Display2D_ScaleZ+Display2D_ShiftZ );
    }

    fill( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    stroke( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    line( (LorenzBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_z_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display2D_ScaleZ+Display2D_ShiftZ, 
      LorenzBufferSize*Display2D_ScaleTime+Display2D_ShiftTime, 
      Lorenz_equation_array[Lorenz_index].get_z()*Display2D_ScaleZ+Display2D_ShiftZ );
  }



  translate( window_size_x/2, window_size_y/2);
  rotateY(radians(mouseX_dragged));
  //rotateX(radians(mouseY_dragged)-PI*3.0/4);
  rotateX(radians(mouseY_dragged)+PI*2.0/4);

  float boxSize = 5.0;
  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) {
    //println(Lorenz_index);
    pushMatrix();
    translate( Lorenz_equation_array[Lorenz_index].get_x()*Display3D_ScaleX+Display3D_ShiftX, 
      Lorenz_equation_array[Lorenz_index].get_y()*Display3D_ScaleY+Display3D_ShiftY, 
      Lorenz_equation_array[Lorenz_index].get_z()*Display3D_ScaleZ+Display3D_ShiftZ );
    fill( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    stroke( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    //fill(0, 0, Lorenz_index*10 );
    //stroke(0, 0, Lorenz_index*10 );

    box(boxSize, boxSize, boxSize);
    popMatrix();
    //println(bvp_neuron[neuron_index_x][neuron_index_y].get_membrane_potential());
  }



  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) {
    for ( int data_index = 0; data_index < LorenzBufferSize - 1; data_index++ ) {
      fill( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      stroke( color_map[Lorenz_index][0], 
        color_map[Lorenz_index][1], 
        color_map[Lorenz_index][2] );
      line( Lorenz_x_buffer[Lorenz_index].get_data( data_index )*Display3D_ScaleX+Display3D_ShiftX, 
        Lorenz_y_buffer[Lorenz_index].get_data( data_index )*Display3D_ScaleY+Display3D_ShiftY, 
        Lorenz_z_buffer[Lorenz_index].get_data( data_index )*Display3D_ScaleZ+Display3D_ShiftZ, 
        Lorenz_x_buffer[Lorenz_index].get_data( data_index + 1 )*Display3D_ScaleX+Display3D_ShiftX, 
        Lorenz_y_buffer[Lorenz_index].get_data( data_index + 1 )*Display3D_ScaleY+Display3D_ShiftY, 
        Lorenz_z_buffer[Lorenz_index].get_data( data_index + 1 )*Display3D_ScaleZ+Display3D_ShiftZ );
    }

    fill( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    stroke( color_map[Lorenz_index][0], 
      color_map[Lorenz_index][1], 
      color_map[Lorenz_index][2] );
    line( Lorenz_x_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display3D_ScaleX+Display3D_ShiftX, 
      Lorenz_y_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display3D_ScaleY+Display3D_ShiftY, 
      Lorenz_z_buffer[Lorenz_index].get_data( LorenzBufferSize - 1 )*Display3D_ScaleZ+Display3D_ShiftZ, 
      Lorenz_equation_array[Lorenz_index].get_x()*Display3D_ScaleX+Display3D_ShiftX, 
      Lorenz_equation_array[Lorenz_index].get_y()*Display3D_ScaleY+Display3D_ShiftY, 
      Lorenz_equation_array[Lorenz_index].get_z()*Display3D_ScaleZ+Display3D_ShiftZ );
  }



  for ( int Lorenz_index = 0; Lorenz_index < LorenzEquationSize; Lorenz_index++ ) { 
    Lorenz_x_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_x() );
    Lorenz_y_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_y() );
    Lorenz_z_buffer[Lorenz_index].push_back( Lorenz_equation_array[Lorenz_index].get_z() );
  }
  //saveFrame("frames/######.png");
}

void mousePressed() {
  mouseX_pressed = mouseX;
  mouseY_pressed = mouseY;
}
void mouseDragged() {
  mouseX_dragged += 0.01*(mouseX-mouseX_pressed);
  mouseY_dragged -= 0.01*(mouseY-mouseY_pressed);
}