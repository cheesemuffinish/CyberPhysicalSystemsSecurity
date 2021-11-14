PROGRAM program0
  VAR
    Conveyer AT %QX100.0 : BOOL;
    SensorA AT %IX100.0 : BOOL;
    SensorB AT %IX100.1 : BOOL;
  END_VAR

  IF SensorA THEN
    Conveyer := TRUE; (*set*)
  END_IF;
  IF SensorB THEN
    Conveyer := FALSE; (*reset*)
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
