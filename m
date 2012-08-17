From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Fri, 17 Aug 2012 01:52:03 +0100
Message-ID: <502D95B3.6030500@anonymous.org.uk>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com> <CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com> <20120507105458.6411b0cf@notabene.brown> <201208161728.13814.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208161728.13814.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/08/2012 00:28, Thomas Fjellstrom wrote:
[...]
> I apologize for bringing back a long dead thread, but I've been wondering if
> mdadm does the grow op in this case, in one step? Or does it internally do
> each step separately, doing a reshape with each one?
>
> I've currently got a 7x1TB disk raid5, and have a couple more disks to add and
> I was planning on moving to raid6. I'm hoping to reduce the amount of time the
> array is "reshaping" because I'm a bit paranoid that my bad luck with hard
> drives will decide to hit right then and there.

If you have a non-degraded 7-disc array, and add two more discs as 
spares, then issue a `mdadm --grow /dev/mdN -l 6 -n 9,` then yes I 
believe it will do it in one pass. There are circumstances where you 
might want to `echo frozen > /sys/block/md/mdN/sync_action` before 
issuing a series of mdadm commands, but I don't think this is one of them.

But if you're worried about your drives, make sure they're clean before 
you start. If you already run weekly scrubs and SMART tests, and they 
come back OK, you should be fine. If you don't, look at your SMART stats 
to see if any of the drives are already in trouble, and rather than 
running a scrub or long SMART tests, just `dd if=/dev/sdX of=/dev/null 
bs=65536` all your drives (though maybe not all at once depending on the 
controllers). Doing that won't kick them out of your raid5 unless a 
drive dies or otherwise totally locks up, and will give you a heads up 
if there may be trouble ahead.

Cheers,

John.

