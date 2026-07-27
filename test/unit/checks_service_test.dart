import 'package:github/github.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group(ChecksService, () {
    late GitHub github;
    late ChecksService checksService;
    Request? lastRequest;

    void setUpGitHub(Future<Response> Function(Request) handler) {
      final client = MockClient((request) async {
        lastRequest = request;
        return handler(request);
      });
      github = GitHub(client: client);
      checksService = ChecksService(github);
    }

    tearDown(() {
      lastRequest = null;
    });

    group(CheckRunsService, () {
      test('reRequestCheckRun', () async {
        setUpGitHub((request) async {
          return Response('', 201);
        });

        final slug = RepositorySlug('owner', 'repo');
        await checksService.checkRuns.reRequestCheckRun(
          slug,
          checkRunId: 123,
        );

        expect(lastRequest, isNotNull);
        expect(lastRequest!.method, 'POST');
        expect(
          lastRequest!.url.path,
          '/repos/owner/repo/check-runs/123/rerequest',
        );
        expect(
          lastRequest!.headers['Accept'],
          'application/vnd.github.antiope-preview+json',
        );
      });
    });

    group(CheckSuitesService, () {
      test('reRequestCheckSuite', () async {
        setUpGitHub((request) async {
          return Response('', 201);
        });

        final slug = RepositorySlug('owner', 'repo');
        await checksService.checkSuites.reRequestCheckSuite(
          slug,
          checkSuiteId: 456,
        );

        expect(lastRequest, isNotNull);
        expect(lastRequest!.method, 'POST');
        expect(
          lastRequest!.url.path,
          '/repos/owner/repo/check-suites/456/rerequest',
        );
        expect(
          lastRequest!.headers['Accept'],
          'application/vnd.github.antiope-preview+json',
        );
      });
    });
  });
}
