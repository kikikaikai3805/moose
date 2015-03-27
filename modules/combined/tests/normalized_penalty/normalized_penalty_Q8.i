[GlobalParams]
  disp_x = disp_x
  disp_y = disp_y
  order = SECOND
  family = LAGRANGE
[]

[Mesh]
  file = normalized_penalty_Q8.e
  displacements = 'disp_x disp_y'
[]

[Problem]
  type = ReferenceResidualProblem
  solution_variables = 'disp_x disp_y'
  reference_residual_variables = 'saved_x saved_y'
[]

[Functions]
  [./left_x]
    type = PiecewiseLinear
    x = '0 1 2'
    y = '0 0.02 0'
  [../]
[]

[Variables]
  [./disp_x]
  [../]

  [./disp_y]
  [../]

[] # Variables

[AuxVariables]

  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./saved_x]
  [../]
  [./saved_y]
  [../]

[] # AuxVariables

[SolidMechanics]
  [./solid]
    save_in_disp_x = saved_x
    save_in_disp_y = saved_y
  [../]
[]

[Contact]
  [./m3_s2]
    master = 3
    slave = 2
    penalty = 1e10
    normalize_penalty = true
    formulation = penalty
    tangential_tolerance = 1e-3
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
    execute_on = timestep_end
  [../]
[] # AuxKernels

[BCs]
  [./left_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 1
    function = left_x
  [../]

  [./y]
    type = PresetBC
    variable = disp_y
    boundary = '1 2 3 4'
    value = 0.0
  [../]

  [./right]
    type = PresetBC
    variable = disp_x
    boundary = '3 4'
    value = 0
  [../]

[] # BCs

[Materials]
  [./stiffStuff1]
    type = Elastic
    block = '1 2 3 4 1000'

    youngs_modulus = 3e8
    poissons_ratio = 0.0

  [../]
[] # Materials

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'



  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu       101'


  line_search = 'none'


  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-8

  l_max_its = 100
  nl_max_its = 10
  dt = 1.0
  num_steps = 2
[] # Executioner

[Outputs]
  output_initial = true
  exodus = true
  print_linear_residuals = true
  hide = 'm3_s2_contact_force_0 m3_s2_contact_force_1'
[] # Output
