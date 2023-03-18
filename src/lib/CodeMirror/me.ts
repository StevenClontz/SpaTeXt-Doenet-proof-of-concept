import type { ElementSpec } from '@codemirror/lang-xml';
import MSpec from './m';

const MeSpec: ElementSpec = {
	name: 'me',
	top: false,
	children: [],
	attributes: MSpec.attributes
};

export default MeSpec;
