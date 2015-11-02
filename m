From: =?UTF-8?Q?Rainer_F=c3=bcgenstein?= <rfu@oudeis.org>
Subject: Re: performance issue
Date: Mon, 2 Nov 2015 23:55:05 +0100
Message-ID: <5637E9C9.70600@oudeis.org>
References: <1092031595.20151015153830@oudeis.org>
 <87si5bvcj4.fsf@notabene.neil.brown.name>
 <43246687.20151024181541@oudeis.org> <20151024213139.5b20dec6@natsu>
 <16514313.20151025202337@oudeis.org>
 <87a8r6g188.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8r6g188.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 25.10.2015 21:08, Neil Brown wrote:
> mdadm --grow /dev/md0 --bitmap=intermnal --bitmap-chunk=256

  not sure how to specify the chunks size:

[root@alfred ~]# mdadm --grow /dev/md0 --bitmap=internal --bitmap-chunk=256
mdadm: failed to create internal bitmap - chunksize problem.
[root@alfred ~]# mdadm --grow /dev/md0 --bitmap=internal --bitmap-chunk=256M
mdadm: invalid bitmap chunksize: 256M
