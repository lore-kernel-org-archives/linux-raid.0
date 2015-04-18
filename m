From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Raid 5 rebuild and Raid 6 reshape question
Date: Sat, 18 Apr 2015 13:38:59 -0600
Message-ID: <1454025.2pEa89kuvv@balsa>
References: <6744821.j7csV3RJVE@balsa> <alpine.DEB.2.02.1504181511310.16871@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504181511310.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat 18 Apr 2015 03:13:52 PM Mikael Abrahamsson wrote:
> On Fri, 17 Apr 2015, Thomas Fjellstrom wrote:
> > I had a 5 disk Raid5 with 3TB disks. One disk threw some errors (but still
> > seemed to work), and i decided to replace it. I actually bought two
> > drives,
> 
> If you have a not-ancient kernel, you should have issued the replace
> command. You should have added one new drive as spare, then (with a new
> mdadm) issued the --replace command. This would have started copying the
> drive you wanted replaced onto the spare. Then after all this was done,
> you could have added another spare and told it to re-shape to raid6.
> That's at least what I would have done.
> 
> http://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-ye
> t-failed-disk-in-a-linux-raid5-array

Yes, I could have. The machine's drive bays were full at the time, it wasnt 
till I had inserted the new drives that I realized i could have left the old 
one in and done a copy or replace. But then the machine was booting without it 
and probably not a great time to put the old disk back in (though an assemble 
force could have brought it back?). It's almost 60% done, so it's not a huge 
problem. I was just curious as to how long an actual raid5->raid6 reshape 
would normally be or this setup. I expect it normally can take a while as it 
has to rewrite a lot of data (11TiB worth).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
