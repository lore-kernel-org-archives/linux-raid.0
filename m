From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: Implementing low level timeouts within MD
Date: Sat, 27 Oct 2007 12:33:57 +0200
Message-ID: <87tzoc7soa.fsf@willow.rfc1149.net>
References: <1193418753.4771.17.camel@w100> <1193425254.10336.290.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Doug" == Doug Ledford <dledford@redhat.com> writes:

Doug> This isn't an md problem, this is a low level disk driver
Doug> problem.  Yell at the author of the disk driver in question.  If
Doug> that driver doesn't time things out and return errors up the
Doug> stack in a reasonable time, then it's broken.  Md should not,
Doug> and realistically can not, take the place of a properly written
Doug> low level driver.

I agree with Doug: nothing prevents you from using md above very slow
drivers (such as remote disks or even a filesystem implemented over a
tape device to make it extreme). Only the low-level drivers know when
it is appropriate to timeout or fail.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

