From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Resize on dirty array?
Date: Sat, 12 Aug 2006 10:22:04 +0300
Message-ID: <5b170a7d0608120022n39742f2cl8f8017f6cc328f5e@mail.gmail.com>
References: <44D7DC93.2070905@net1plus.com>
	 <17623.57067.835826.446152@cse.unsw.edu.au>
	 <44D8E535.9080208@net1plus.com>
	 <17625.24594.568139.430440@cse.unsw.edu.au>
	 <44D9C6F5.7070501@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D9C6F5.7070501@net1plus.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 8/9/06, James Peverill <jamespev@net1plus.com> wrote:
>
> I'll try the force assemble but it sounds like I'm screwed.  It sounds
> like what happened was that two of my drives developed bad sectors in
> different places that weren't found until I accessed certain areas (in
> the case of the first failure) and did the drive rebuild (for the second
> failure).  In the future, is there a way to help prevent this?

This is a common scenario, and I feel could be helped if md could be
told to not drop the disk on first failure, but rather keep it running
in "FAILING" status (as opposed to FAILED), until all data from it has
been evacuated (hot spare). This way, if another disk became "failing"
during rebuild, due to another area of the disk, those blocks could be
rebuilt using the other "failing" disk. (Also, this allows for the
rebuild to mostly be a ddrescue-style copy operation, rather than
parity computation).

Do you guys feel this is feasible? Neil?
