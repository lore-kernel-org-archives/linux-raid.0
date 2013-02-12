From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: raid/device failure
Date: Tue, 12 Feb 2013 15:31:29 -0700
Message-ID: <201302121531.29580.thomas@fjellstrom.ca>
References: <201302101827.36116.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201302101827.36116.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun February 10, 2013, Thomas Fjellstrom wrote:
> I've re-configured my NAS box (still haven't put it into "production") to
> be a raid5 over 7 2TB consumer seagate barracuda drives, and with some
> tweaking, performance was looking stellar.
> 
> Unfortunately I started seeing some messages in dmesg that worried me:
> 
> mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11),
> sub_code(0x0d01)
> 
[snip]

So the more serrious issues are gone after some tests, but the above message 
is back after a while:

mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11), sub_code(0x0d01)

I tried looking through the mpt code for the sub code 0x0d01, but it didn't 
seem to be in the code at all. Does anyone know what that means?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
