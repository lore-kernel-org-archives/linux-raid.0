From: Jeff Garzik <jeff@garzik.org>
Subject: Re: How many disks per SATA-II bus?
Date: Tue, 29 Jan 2008 14:15:24 -0500
Message-ID: <479F7B4C.7000602@garzik.org>
References: <214675.77163.qm@web88308.mail.re4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <214675.77163.qm@web88308.mail.re4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: subscribe@brmiller.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bruce Miller wrote:
> The beginning of Section 4 of the Linux Sotfware-RAID-HOWTO
> states emphatically that "you should only have one device per
> IDE bus. Running disks as master/slave is horrible for
> performance. IDE is really bad at accessing more that one drive
> per bus".
> 
> Do the same cautions apply to building a RAID array using
> SATA-II disks?

SATA is a point-to-point serial connection, totally different technology.

	Jeff



