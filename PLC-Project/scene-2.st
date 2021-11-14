PROGRAM program0
  VAR
    Conveyer AT %IX0.0 : BOOL;
    SensorA AT %QX0.0 : BOOL;
    SensorB AT %QX0.1 : BOOL;
  END_VAR

  IF NOT(SensorA) THEN
    Conveyer := TRUE; (*set*)
  END_IF;
  IF NOT(SensorB) THEN
    Conveyer := FALSE; (*reset*)
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
