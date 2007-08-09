From: Neil Brown <neilb@suse.de>
Subject: Re: Linux RAID migration
Date: Thu, 9 Aug 2007 13:23:50 +1000
Message-ID: <18106.35014.658463.939070@notabene.brown>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
	<5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
	<c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com>
	<18104.18410.623573.929770@notabene.brown>
	<c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com>
	<c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com>
	<18104.21737.341407.654022@notabene.brown>
	<c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com>
	<18104.23111.369229.891505@notabene.brown>
	<c70ff3ad0708070627r3a20f8faud8fd3cca9f87195@mail.gmail.com>
	<c70ff3ad0708070815i1797f9d9qe10ed7945f483033@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from saeed bishara on Tuesday August 7
Sender: linux-raid-owner@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 7, saeed.bishara@gmail.com wrote:
> > >   mdadm --grow /dev/md0 --raid-disks=3
> the mdadm --grow supports saving backup file that can be used to
> re-assemble the array in case of crash during the "critical section".
> Any idea what is the size of file? or is there any upper limit in the
> case of array of 5 drives?

The file size depends on the chunk size and the number of disks.

I think for 5 disks it would be less than 30 times the chunk size, so
for a 128K chunk, it would be under 3 Meg.

NeilBrown
