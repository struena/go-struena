Pod::Spec.new do |spec|
  spec.name         = 'Struena'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/struena/go-struena'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS struena Client'
  spec.source       = { :git => 'https://github.com/struena/go-struena.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/Struena.framework'

	spec.prepare_command = <<-CMD
    curl https://struenastore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/Struena.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
