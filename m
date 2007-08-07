From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: Linux RAID migration
Date: Tue, 7 Aug 2007 13:46:32 +0300
Message-ID: <c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
	 <5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
	 <c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com>
	 <18104.18410.623573.929770@notabene.brown>
	 <c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

how can I create raid 5 array that preserves the contents of a given
disk (part of the array)?
I can do that in two steps, raid 5 on two disks then reshape it to be
real raid5, but is there a direct way to do it?

saeed
