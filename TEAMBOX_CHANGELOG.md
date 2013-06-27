Teambox fork of mikel/mail
==========================

* Why? -  Commit e1d624f is required to fix On-Premise issues (see Changelog below).
          Commit e1d624f is only available in `mail` release 2.5.4.
          This release does not exist in any current Rails versions.
          Rails 4.0.0 has a hard dependency on `mail` 2.5.x (currently 2.5.3).
          In theory we could remove this fork after upgrading to Rails 4.x.

* How? -  If we upgrade rails to a version that bumps the `mail` gem then this fork needs to updated.

          - Recreate the `teambox` branch from new fork point:
             1. `git checkout new_tag`
             2. `git checkout -b teambox_new`
             3. `git branch -D teambox`
             4. `git branch -m teambox_new teambox`
             5. `git push -u orgin teambox --force`

          - Apply patch:

            1. `git cherry-pick e1d624f`
            2. Fix any conflicts.
            3. Commit.

          - Update this document and commit.
          - git push to update remote teambox branch.

          - In Hosted repository (Assuming the `gem 'mail'` points to this repository):
              1. `bundle update mail`
              2. `bundle package --all`
              3. `git add vendor/cache --force`
              4. `git add -u` # stages any deleted stale gems
              5. commit and push

Fork Point
-----------

Tag: 2.4.4

Changelog
---------

* Cherry pick (e1d624f - "The Received header may contain zero name/value pairs, qmail-style (jeremy)")

  * Fixes github issue #202 (https://github.com/mikel/mail/issues/202)
  * Fixes teambox issue #3753506 (https://teambox.com/#!/projects/teambox-enterprise-accounts/tasks/3753506)
  * Fixes teambox issue #3718876 (https://teambox.com/#!/projects/teambox-onpremise-support/tasks/3718876)

