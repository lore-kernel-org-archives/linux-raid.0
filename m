From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: using dd (or dd_rescue) to salvage array
Date: Sat, 04 Feb 2012 19:01:36 +0100
Message-ID: <4F2D7280.8020500@stud.tu-ilmenau.de>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us> <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us> <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 03.02.2012 17:08, schrieb Keith Keller:
> On 2012-02-01, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>>
>> Well, for better or worse, this is now a moot question--I had another
>> drive kicked out of the array, I believe prematurely by the controller.
> 
> It turns out to be worse--the drive does in fact appear to be failing,
> which would be the third failure on this RAID6 array.  I had what might
> be a crazy thought--would it be worth the trouble to attempt to use dd
> (or dd_rescue, a tool I found that claims to continue on bad blocks) to
> write the disk image to another disk, and attempt a rebuild with the new
> disk?  Or am I just wasting my time?  (The array is hosting an rsnapshot
> backup set, so I can recreate the latest snapshot, but it'll take a
> while.  So it'd be nice to save the array if it's possible and not time-
> consuming.)
> 
> Thanks for your help!
> 
> --keith
> 
Hi Keith,

actually, ddrescue is THE WAY TO GO in this case.  Don't use the old
ddrescue, but the GNU version.  Some distros call it gddrescue, on
gentoo the old one is called dd-rescue and the gnu-one ddrescue.  Just
check it out: http://www.gnu.org/software/ddrescue/ddrescue.html

Good luck,
Stefan
