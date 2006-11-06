From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Checking individual drive state
Date: Sun, 05 Nov 2006 18:47:03 -0800
Message-ID: <454EA227.5060603@h3c.com>
References: <454E02EE.5030209@gmail.com> <Pine.LNX.4.64.0611051237080.13706@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611051237080.13706@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Bradshaw <breadlord@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



dean gaudet wrote:
> On Sun, 5 Nov 2006, Bradshaw wrote:


>> I don't know how to scan the one disk for bad sectors, stopping the array and
>> doing an fsck or similar throws errors, so I need help in determining whether
>> the disc itself is faulty.
> 
> try swapping the cable first.  after that swap ports with another disk and 
> see if the problem follows the port or the disk.
> 
> you can see if smartctl -a (from smartmontools) tells you anything 
> interesting.  (it can be quite difficult, to impossible, to understand 
> smartctl -a output though.  but if you've got errors in the SMART error 
> log that's a good place to start.)

I don't think SMART output is that hard to understand.

And checking the entire drive for errors is as easy as 'smartctl -t long
/dev/<drive>' usually. If it is SATA as you say, you may need to put a
'-d ata' in there.

Wait for however long it says to wait, then do a 'smartctl -a
/dev/<drive>' and you should see the self test log at the bottom. Did it
finish? If not, there are bad sectors. If there are bad sectors, you
should google the string 'BadBlockHowTo' to see if you can clear them
(after failing the drive out of the array)

Note that this won't tell you anything about cables or controllers or
power or anything else that could and may be wrong. It's just for the
drive media and firmware.

-Mike
