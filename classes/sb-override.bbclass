# Adds ":sb" to OVERRIDES, so other layers can use VAR:machine:sb
# overrides that only apply when this layer is inherited.
python () {
    overrides = d.getVar('MACHINEOVERRIDES') or ''
    if 'sb' not in overrides.split(':'):
        d.setVar('MACHINEOVERRIDES', overrides + ':sb')
}
