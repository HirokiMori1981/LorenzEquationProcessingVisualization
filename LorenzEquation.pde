class LorenzEquation {
  float ConstantP;
  float ConstantR;
  float ConstantB;

  float InitialX;
  float InitialY;
  float InitialZ;

  float x;
  float y;
  float z;

  float TimeConstant;
  float delta_t;

  LorenzEquation() {
    ConstantP=10.0;
    ConstantR=28;
    ConstantB=8.0/3.0;


    InitialX=0.0;
    InitialY=0.0;
    InitialZ=0.0;

    x=0.0;
    y=0.0;
    z=0.0;

    TimeConstant = 1.0;
    delta_t=0.01;
  }


  void update() {
    x += diff_x()*delta_t;
    y += diff_y()*delta_t;
    z += diff_z()*delta_t;
  }
  void set_initial_states( float initial_x, float initial_y, float initial_z ) {
    InitialX = initial_x;
    InitialY = initial_y;
    InitialZ = initial_z;
  }

  void set_parameters( float delta_T, 
    float time_constant, 
    float constant_p, 
    float constant_r, 
    float constant_b ) {
    delta_t = delta_T;
    TimeConstant = time_constant;
    ConstantP = constant_p;
    ConstantR = constant_r;
    ConstantB = constant_b;
  }


  float get_x() {
    return x;
  }
  float get_y() {
    return y;
  }
  float get_z() {
    return z;
  }
  void reset() {
    x = InitialX;
    y = InitialY;
    z = InitialZ;
  }

  float diff_x() {
    //std::cout << "ref" << std::endl;
    return ConstantP*(- x + y)/TimeConstant;
  }
  float diff_y() {
    return ( -x * z + ConstantR * x - y )/TimeConstant;
  }
  float diff_z() {
    return ( x * y - ConstantB * z )/TimeConstant;
  }
}