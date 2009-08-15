From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Software, Raid 5, Different Size Drives.
Date: Sat, 15 Aug 2009 11:54:13 -0700 (PDT)
Message-ID: <914153.25662.qm@web51308.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi quick Q.. I have a 6 drive array made up of 4 500GB's and 2 750GB's.

I know the array will only take on a size based on the smallest drive. To that end as I phase drives out based on usage etc I replace them with the best value drive I can lay my hands on (upto 1TB~ as i have read a raid 5 array of drives over that size approx start to cause problems with read failures on re-builds - but that is for another thread)

So my array is currently ~2.5GB with 2x250GB currently not in use and I am about to phase out a 500GB and replace with a 1TB. Now i have read that you are better of creating a auto detect raid partition on the drive and adding that rather than adding the entire drive (so sda1 not sda). This is where my question comes in. I have read that 2 1TB(or whatever size) can be different block sizes and hence adding a partition that is the entire drive can cause problems as these sizes will differ.

Can anyone tell me what truth there is in this? Should I actually create a partition  that is always going to be a nice multiple size smaller so i can smooth over the bumps?

(also anyone know if raid5 to raid 6 native support is anywhere near?)

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'
-----------------------

Send instant messages to your online friends http://uk.messenger.yahoo.com 
