From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Array of disks attached to multiple controllers
Date: Tue, 14 Sep 2004 09:57:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409141357.i8EDvg332052@watkins-home.com>
References: <4146F05C.9090206@opf.slu.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4146F05C.9090206@opf.slu.cz>
To: 'Lukas Kubin' <kubin@opf.slu.cz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Give us more info.
Output from mdadm -D /dev/md?

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lukas Kubin
Sent: Tuesday, September 14, 2004 9:22 AM
To: linux-raid@vger.kernel.org
Subject: Array of disks attached to multiple controllers

I'm having troubles creating Raid-5 array consisted of 16 (+1 spare) 
disks attached to two 3ware (not same version) SATA controllers.

Mkraid creates the array without problems, however the array's total 
size only equals the sum of space on drives attached to the first of 2 
controllers. Ie, sd{b..f} are on scsi0 and sd{g..r} on scsi1. The space 
of created array is close to the sum of drives attechted to scsi0 only.

Is it possible to combine drives on 2 controllers into one array? If 
not, what solution should I use to have one filesystem containing whole 
the drivespace on Raid-5?

Thank you.

lukas

-- 
Lukas Kubin

phone: +420596398275
email: kubin@opf.slu.cz

Information centre
The School of Business Administration in Karvina
Silesian University in Opava
Czech Republic
http://www.opf.slu.cz

