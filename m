From: bernd@rhm.de
Subject: Re: RAID1 robust read and read/write correct and EVMS-BBR
Date: Wed, 23 Feb 2005 22:22:58 +0100 (MEZ)
Message-ID: <200502232122.WAA20465@node130.rhm.de>
References: <CAC3BCBB443DEC439198F230B4BCC7E9092C45CC@exna6-ftsaa.mis.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAC3BCBB443DEC439198F230B4BCC7E9092C45CC@exna6-ftsaa.mis.stratus.com> from "Nagpure, Dinesh" at "Feb 23, 5 02:55:45 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Nagpure Dinesh <Dinesh.Nagpure@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

....
>I can go back and put together a patch over the weekend if anyone is
>interested in using it. 
>
>-dinesh
>dinesh.nagpure@stratus.com
>-

Oh yes, please make this patch. We are very very interested in it!

We are waiting for the one day where the same block on all mirrors has
read problems. Ok, we're now waiting for about 15 years because the
HPUX mirror strategy is the same. Quite a long time without desaster
but it will happen (till today Murphy was right in any case but one:-)).
If anything happens to a disk one must be warned as soon as possible.

Thanks
B. Rieke (bernd@rhm.de)
