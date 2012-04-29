From: likewhoa <likewhoa@weboperative.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sun, 29 Apr 2012 10:23:26 -0400
Message-ID: <4F9D4EDE.50504@weboperative.com>
References: <4F9AFBC6.7070803@weboperative.com> <4F9B14FA.1090001@weboperative.com> <20120428080522.637bc564@notabene.brown> <4F9B2BE1.5080207@weboperative.com> <4F9B3B48.8020900@weboperative.com> <4F9B57E9.2060409@weboperative.com> <20120428125506.6a2388eb@notabene.brown> <4F9B5D24.1050708@weboperative.com> <20120428132331.01396da6@notabene.brown> <4F9B695D.8030105@weboperative.com> <4F9C0B66.90102@weboperative.com> <20120429072844.5e0001b0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120429072844.5e0001b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/28/2012 05:28 PM, NeilBrown wrote:
> I would just list the UUID for each array:
>    ARRAY /dev/md0 uuid=.......
> and leave it at that.
I used the output of 'mdadm -Esv' then removed everything but UUID=...
but after doing 'mdadm -A /dev/md1' I get "mdadm: failed to add 8:131 to
/dev/md1: Invalid argument
mdadm: /dev/md1 assembled from 0 drives - not enough to start the
array." mdadm.conf has "ARRAY /dev/md/1
UUID=158918a9:52356b95:f4926a78:a55d4509" so not sure what could be the
problem since it should just work.

