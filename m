From: "John Robinson" <john.robinson@anonymous.org.uk>
Subject: Re: max number of devices in raid6 array
Date: Wed, 12 Aug 2009 17:33:00 +0100 (BST)
Message-ID: <60099.78.86.108.203.1250094780.squirrel@www.yuiop.co.uk>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>   
    <55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>   
    <20090812121911.GG21118@nfs-rbx.ovh.net>   
    <87ab259j8m.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ab259j8m.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: David Cure <lnk@cure.nom.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 August, 2009 3:53 pm, Goswin von Brederlow wrote:
[...]
> And compute the overall MTBFS. With how many devices does the MTBFS of a
raid6 drop below that of a single disk?

First up, we probably want to be talking about Mean Time To Data Loss.
It'll vary enormously depending on how fast you think you can replace dead
drives, which in turn depends on how long a rebuild takes (since a dead
drive doesn't count as having been replaced until the new drive is fully
sync'ed). And building an array that big, it's going to be hard to get
drives all from different batches.

Anyway, someone asked Google a similar question:
http://answers.google.com/answers/threadview/id/730165.html and the MTTDL
for an 11-disc RAID-5 with 100,000-hour drives and a 24-hour
replacement+rebuild turnaround was 3.8 million hours (433 years), and a
RAID-6 was said to be "hundreds of times" more reliable. The 433 years
figure will be assuming that one drive failure doesn't cause another one,
though, so it's to be taken with a pinch of salt.

Cheers,

John.



