"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestIngSoftTests,
	#superclass : #PackageManifest,
	#category : #'IngSoft2-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestIngSoftTests class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'IngSoft2-Tests')) #'2021-07-25T18:02:18.051976-03:00') )
]
