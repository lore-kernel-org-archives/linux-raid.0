From: Aryeh Leib Taurog <vim@aryehleib.com>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Fri, 2 Jan 2015 16:02:06 +0200
Message-ID: <20150102140206.GD6294@deb76.aryehleib.com>
References: <54A67A8C.8080803@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54A67A8C.8080803@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 02, 2015 at 11:02, Anthonys Lists wrote:
>On 01/01/2015 20:54, Robert L Mathews wrote:
>>> >Personalities : [raid1]
>>> >md126 : active (auto-read-only) raid1 sdc2[0]
>>> >       943587136 blocks super 1.2 [2/1] [U_]
>>> >       
>>> >md127 : active (auto-read-only) raid1 sdd2[1]
>>> >       943587136 blocks super 1.2 [2/1] [_U]
>> Still sdc2 and sdd2, although now in two arrays.
>>
>>
> What version is mdadm? iirc there is a known bug in older versions 
> which does this. (Splits one array into two arrays.)

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

It's the mdadm packaged with Debian wheezy
