From: zhilong <zlliu@suse.com>
Subject: exposed and pushed the mdadm/test improvement progress
Date: Mon, 27 Feb 2017 20:37:33 +0800
Message-ID: <a81137d5-3042-e983-fe0e-1b9a0de836ff@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

hi, Neil and Jes;

    Several weeks ago, the mdadm version 4.0 has announced and we talked 
about how to improve the testing part in that mail-tree.
I have spent two weeks to verify the testing part in different testing 
environments include of
    kernel:                                    mdadm: 
                                   filesystem:
    SUSE 12 SP2 Enterprise      mdadm 4.0 source code       ext3, ext4 
and btrfs
    linux upstream 4.10             mdadm 
4.0                             ext3, ext4 and btrfs

    According to the two weeks' testing and my understanding, my first 
step has done to redraft the 'test' script, as my purpose,
I mainly made it easier to read, added some important checking I thought 
and changed some func(). After the 'test' file has done,
the second part is to improve every case under tests/ folder.

    The 'tests/check' and 'tests/testdev' files would be deleted after 
finish the testing part improvement. I have added comments in the
RFC patch, I wanna ask for all ideas about the testing improvement in 
the mailing-list, would you have any suggestion?

Thanks very much,
-Zhilong
