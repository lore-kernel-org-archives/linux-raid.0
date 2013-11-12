From: "John Stoffel" <john@stoffel.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Mon, 11 Nov 2013 21:49:08 -0500
Message-ID: <21121.38692.485478.101911@quad.stoffel.home>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<527E8B74.70301@shiftmail.org>
	<008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
	<527F7FF5.3000002@shiftmail.org>
	<000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
	<5280BA1E.6060604@shiftmail.org>
	<CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
	<21121.19173.938188.985528@quad.stoffel.home>
	<20131112085556.766f095b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131112085556.766f095b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.de> writes:

NeilBrown> On Mon, 11 Nov 2013 16:23:49 -0500 "John Stoffel" <john@stoffel.org> wrote:
>> 
>> I thought you could also get a mis-match count from open mmap'd files,
>> which aren't completely written to one disk or another?  
>> 

NeilBrown> The only cause I can imagine for the mismatch count
NeilBrown> increasing is for a page of memory to be change while it is
NeilBrown> being written out (so each device sees a different value)
NeilBrown> and then for the page to be invalidated (so the dirty page
NeilBrown> never gets written out again).

NeilBrown> The only way to change a page while it is being written out
NeilBrown> is (I think) through memory mapping (though this could have
NeilBrown> change, "write" might achieve it).

NeilBrown> But normally if you change a memory mapped page while it is
NeilBrown> being written it will be marked 'dirty' and so will be
NeilBrown> written out again - the same to both devices.

NeilBrown> You could possibly modify a mem-mapped file, and then
NeilBrown> delete it before the latest changes were written, but think
NeilBrown> that would be unlikely to do on purpose.

NeilBrown> Swap is the most likely cause.  If some pages in a process
NeilBrown> were written out and changed during the writeout, and then
NeilBrown> the process was killed, you could easily get a mismatch
NeilBrown> persisting.

I think it is swap in my case, it's a RHEL 5.6 box being used to host
VNC sessions for my users.  They do weekly checks on the mirrored
disks, and I think I get mis-match counts because swap is on MD too.  

John
