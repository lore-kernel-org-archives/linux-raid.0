From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 00:16:12 +0200
Message-ID: <ivvmqq$kan$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk> <iuf6me$9us$1@dough.gmane.org> <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tom De Mulder wrote:
> I have a set of 4 Intel 510 SSDs purely for testing, and I have used 
> these to simulate the kinds of workload I would expect them to 
> experience in a server environment

Beware: The Intel SSDs are documented to voluntarily throttle write 
speed if they detect a lot of writing going on to meet their lifetime 
advertisement.

(I have not read such in the documentation of 
marvell/micron/indilinx/sandforce controllers, and indeed, when wiped 
once per week, our SSDs keep up their initial performance. And yes, I 
find it acceptable that they might wear out after >= 3 years :-)

Regards,

Lutz Vieweg


