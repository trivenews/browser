import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:trive_core/trive_core.dart';
import 'synchronization_service.dart';

@Component(
    selector: 'trive-claim',
    styleUrls: const ['claim.css'],
    templateUrl: 'claim.html',
    providers: const [
        SynchronizationService,
        materialProviders,
    ],
)
class ClaimComponent {

    @Input()
    Claim claim;

    ClaimComponent() {
    }

    onSave([_]) {
    }

    onDelete([_]) {
    }

}


