From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: Question regarding the adding of drives to a RAID
Date: Tue, 16 Mar 2004 15:58:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01e501c40baa$32b20590$350e10ac@pinchy>
Reply-To: mcuss@cdlsystems.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I've read through the Software RAID HowTo (a very helpful document) and
searched through the mailing list, but haven't been able to find the answer
to my question, so here goes:

Suppose I have a RAID 1 (striping) RAID set up consisting of two drives,
creaiedby editing raidtab and issuing an mkraid, etc.  Suppose I've made an
ext3 filesystem on this device and have files on it.

Now, suppose this RAID device is full, and I wish to make it bigger.  Is
there a way for me to add another pair of drives to this array?  I've tried
doing a "raidhotadd" on my experimental box, that that didn't work.  Later
reading revealed that raidhotadd is only for adding spares.  I don't think
simply adding the new drives to the raidtab will help, as those changes will
only become effective if I mkraid the device, which will torch the data on
it.

Is it possible to do this, or am I dreaming?

Thanks

Mark

Mark Cuss, B. Sc.
Real Time Systems Analyst
System Administrator
CDL Systems Ltd
Suite 230
3553 - 31 Street NW
Calgary, AB, Canada

Phone: 403 289 1733 ext 226
Fax: 403 282 1238
www.cdlsystems.com


