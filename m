From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/3] mdadm/test: Refactor the codes of 'test' script
Date: Wed,  7 Jun 2017 17:31:25 +0800
Message-ID: <1496827888-17118-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  This patchset mainly focus on improving the 'test' script, rip it
apart and put it together in a more coherent form.
  Over 3 months passed, the RFC patch of improving 'test' hadn't received
any ideas, thus I post this sample version that I have tested many times.
  It's just the beginning to improve the test part of mdadm, any questions
is very welcome.

  Sorry for that, I haven't added the function suggested from Guoqing, cut
the words from the email tree of 
"ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under Linux":

Guoqing asked:
...
Is current test can run the test for different raid level, say, 
"./test --raidtype=raid1" 
could execute all the *r1* tests, does it make sense to do it if we don't
support it now. 
...

  Just list this suggestion here, waiting for ideas.

RFC patch mail-tree:
[PATCH RFC] test: revise 'test' and make it easier to understand
Acked-by: Neil Brown
And suggest to split those changing into smaller patches from Guoqing.


Thanks very much,
Zhilong

Zhilong Liu (3):
  mdadm/test: Convert code format to use Tab
  mdadm/test: Refactor the codes of 'test' script
  mdadm/test: Get rid of fast_sync()

 test | 803 +++++++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 446 insertions(+), 357 deletions(-)

-- 
2.6.6

