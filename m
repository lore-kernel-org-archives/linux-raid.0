From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: raid 5 to raid 6 reshape gone bad
Date: Sat, 12 Nov 2011 19:55:49 -0800
Message-ID: <5nr3p8x4of.ln2@goaway.wombat.san-francisco.ca.us>
References: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
 <4dq3p8xsef.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-11-13, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> Do you have hot-swap drives?  If so, simply mark sdd3 as faulty with
> mdadm, remove it from the array, then physically remove and replace it
> and use mdadm to add the new drive.  The raid6 should start to rebuild
> automatically.

...or, better still, don't listen to me and take Neil's advice.  :)

--keith


-- 
kkeller@wombat.san-francisco.ca.us

