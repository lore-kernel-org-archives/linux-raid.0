From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: Uh oh....
Date: 30 Jan 2003 00:30:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yq1y953ryq4.fsf@austin.mkp.net>
References: <028201c2c81c$f05ab0b0$1400020a@mike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <028201c2c81c$f05ab0b0$1400020a@mike>
To: Michael Paul <radius.mp@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Michael" == Michael Paul <radius.mp@verizon.net> writes:

Michael> The box in which some of my scsi drives were located did not
Michael> get turned on when I booted. So, of course, all of my mirrors
Michael> are now in degraded mode. Is there a quick and easy way to
Michael> fix this?

        mdadm /dev/mdM -a /dev/sdxN

-- 
Martin K. Petersen	Wild Open Source, Inc.
mkp@wildopensource.com	http://www.wildopensource.com/

