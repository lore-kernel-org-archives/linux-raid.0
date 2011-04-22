From: Chris Weiss <cweiss@gmail.com>
Subject: Re: [Scst-devel] Tuning scst windows and sw raid5
Date: Fri, 22 Apr 2011 09:19:48 -0500
Message-ID: <BANLkTiktSichu5PT7LUb0nLzOe=chq3s1A@mail.gmail.com>
References: <201104221608.50195.lukasz.oles@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104221608.50195.lukasz.oles@open-e.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?xYF1a2FzeiBPbGXFmw==?= <lukasz.oles@open-e.com>
Cc: scst-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 22, 2011 at 9:08 AM, =C5=81ukasz Ole=C5=9B <lukasz.oles@ope=
n-e.com> wrote:
> Hi,
>
> I'm trying to tune Software Raid5, SCST and Windows Initiator to get =
best
> read/write performance.

My first recommendation is to stick with blockio due to the raid5
write hole possibility when using software raid.

what windows version, and if not server2008, did you align the
partitions? (there's a 2003 and a 2008 R2)

dd is going to use the initiator OS's cache, make sure your test file
size is 2x the ram in the initiator, if not the target too.

Also xfs is much better at dealing with large files than ntfs.  Best
apple to apples test is going to be on raw unformated partitions

I'm not familiar with BST5.  I typically use iometer for both OS's.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
