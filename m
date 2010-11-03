From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: Re: Determining which spindle is out of order
Date: Wed, 3 Nov 2010 15:59:41 +0000
Message-ID: <AANLkTim7F+JVDb008XkcH0+4t+vzivV6CprejAQp5xa1@mail.gmail.com>
References: <loom.20101103T115828-494@post.gmane.org>
	<4CD17583.6070909@seoss.co.uk>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD17583.6070909@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: Nat Makarevitch <Shelso@makarevitch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use something like this.. when i commission a drive I allocate it a
unique number like J70 and I then have a spreadsheet that marrys this
up with the serial number of the device.

hdparm etc gives me the serial number, and the lookup identifies the device.

Oh and i write the J70 on little green sticky labels that I then stick
on all 4 edges of the drive...
