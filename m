From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: Linux RAID migration
Date: Tue, 7 Aug 2007 18:15:48 +0300
Message-ID: <c70ff3ad0708070815i1797f9d9qe10ed7945f483033@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c70ff3ad0708070627r3a20f8faud8fd3cca9f87195@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >   mdadm --grow /dev/md0 --raid-disks=3
the mdadm --grow supports saving backup file that can be used to
re-assemble the array in case of crash during the "critical section".
Any idea what is the size of file? or is there any upper limit in the
case of array of 5 drives?

saeed
