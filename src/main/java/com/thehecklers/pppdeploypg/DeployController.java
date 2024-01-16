package com.thehecklers.pppdeploypg;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class DeployController {
    @GetMapping
    public String getDeploy() {
        return "Deployed!";
    }
}
