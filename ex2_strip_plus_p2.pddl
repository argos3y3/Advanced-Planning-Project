(define (problem ex2_strip_plus_p2)
    (:domain ex2_strip_plus)
    ; OBJECT DEFINITION
    (:objects
       depot1 - depot ;; our initial depot1
       location1 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 - box ;; three box avaiable
       person1 person2 - person ;; person to be rescued
       ; content to be delivered
       content1 - food
       content2 - tool
       content3 - medicine
       ; carrier
       carrier1 - carrier
    )
    ; PREDICATE DEFINITION    
    (:init
        ; all box, content, agent at depot1 initially
        ; box initial position
        (be_at_box box1 depot1)
        (be_at_box box2 depot1)
        (be_at_box box3 depot1)    
        ; content initial position
        (be_at_content content1 depot1)
        (be_at_content content2 depot1)
        (be_at_content content3 depot1)
        ; robot initial position
        (be_at_robot depot1 robot1)
        ; people initial position
        (be_at_person location1 person1)
        (be_at_person location1 person2)    
        ; box initial empty
        (empty_box box1)
        (empty_box box2)
        (empty_box box3)
         ; box not assigned
        (not_is_assigned_box box1)
        (not_is_assigned_box box2)
        (not_is_assigned_box box3)
        ; is necessary to set true negated version of predicates
        ; no content is assigned to anyone
        (not_assigned_person_content content1 person1)
        (not_assigned_person_content content2 person1)
        (not_assigned_person_content content3 person1)
        (not_assigned_person_content content1 person2)
        (not_assigned_person_content content2 person2)
        (not_assigned_person_content content3 person2)
        ; no box is full
        (not_assigned_box_content box1 content1)
        (not_assigned_box_content box2 content1)
        (not_assigned_box_content box3 content1)
        (not_assigned_box_content box1 content2)
        (not_assigned_box_content box2 content2)
        (not_assigned_box_content box3 content2)
        (not_assigned_box_content box1 content3)
        (not_assigned_box_content box2 content3)
        (not_assigned_box_content box3 content3)
        ; no box is assigned to any robot 
        (not_assigned_carrier_box box1 carrier1)
        (not_assigned_carrier_box box2 carrier1)
        (not_assigned_carrier_box box3 carrier1)
        ; no content is assigned
        (not_is_assigned content1)
        (not_is_assigned content2)
        (not_is_assigned content3)
        ; set capacity
        (carrier_capacity_4 carrier1)
        ; assign carrier
        (assigned_robot_carrier  carrier1 robot1)
    )
    ; GOAL DEFINITION
    (:goal
        (and
            (assigned_person_content content1 person1)
            (assigned_person_content content2 person1)
            (assigned_person_content content3 person2)
        )
    )
)
