From: Anthony DeRobertis <anthony@derobert.net>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Tue, 20 Sep 2016 13:52:10 -0400
Message-ID: <656fe196-b2fb-5ae6-797a-79f46dd1f6d7@derobert.net>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
 <57E10311.7040601@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E10311.7040601@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids

BTW: the change from apparently working but spewing errors back to not 
working is:

bbc24bb35020793b9e6fa2111b15882f0dbfe36e is the first broken commit
commit bbc24bb35020793b9e6fa2111b15882f0dbfe36e
Author: Guoqing Jiang <gqjiang@suse.com>
Date:   Mon May 9 10:22:58 2016 +0800

     super1: make the check for NodeNumUpdate more accurate
     
     We missed to check the version is BITMAP_MAJOR_CLUSTERED
     or not, otherwise mdadm can't create array with other 1.x
     metadatas (1.0 and 1.1).
     
     Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
     Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

:100644 100644 972b4700455426d47f52141416d873b6c745fa07 fa933676621f6431398192b1c0b26f3ce53deac3 M      super1.c


