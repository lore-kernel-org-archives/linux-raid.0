From: Phil Turmel <philip@turmel.org>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Fri, 06 Jan 2012 09:51:32 -0500
Message-ID: <4F070A74.3010208@turmel.org>
References: <4E6F13F7.6070507@truschnigg.info> <4E6F4091.7050206@turmel.org> <4E6FA76A.90206@truschnigg.info> <4E7092F1.5010209@turmel.org> <4E70EFA8.4080706@truschnigg.info> <4E70FE5B.5080601@turmel.org> <20120106105143.GA2932@vault.local> <4F06F410.4070807@turmel.org> <20120106134625.GA3027@vault.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120106134625.GA3027@vault.local>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/06/2012 08:46 AM, Johannes Truschnigg wrote:
> Good morning Phil,
> 
> thanks for tuning in again! :)
> 
> On Fri, Jan 06, 2012 at 08:16:00AM -0500, Phil Turmel wrote:
>> Warning!  I saw bug report on LKML yesterday involving LVM and the brand new
>> kernel v3.2, so you might want to pull back.  v3.1.5 was known good in that
>> report.
> 
> Ok, thanks for the warning - will try to find the thread where the bug is
> described, and consider downgrading to 3.1.x instead!

https://lkml.org/lkml/2012/1/5/76

Note that it involves ext4 and LVM snapshots, so may not apply to you.  But the
bug hasn't been clearly identified, so my paranoid approach to kernels would
keep me off of it. (On production systems, of course.  I regularly run -rc
kernels on my laptop.)

>> I'm guessing that /dev/sda contains your boot and root filesystems, and that
>> this isn't an error.
> 
> You are correct, sorry I did not mention that initially. These devices are not
> supposed to end up as parts of any md arrays.
> 
>> Those slot numbers are *really* important.
> 
> What is the significance of the individual slot numbers there?

You would need them if you ever ran into some catastrophic problem where
"--create --assume-clean" was needed.

>> Yes, --assemble --force.
> 
> Ok, will fire that command as soon as I checked out the LVM bug you mentioned.

Actually, given the /proc/mdstat contents you reported, you might be able to just
do "mdadm --run /dev/md0"

>> May I suggest getting an lsdrv [1] report, which will give you the serial numbers
>> of your disks versus the device assignments, for later reference.  And again
>> after it's all running, for completeness.
> 
> I have attached a file with the relevant lsdrv (great little program btw) to
> this message - should I expect changes to it after my array is up (well,
> except for the components not to be recognized as spare, of course)?

The output will change substantially, as it attempts to map the entire
storage tree, reporting all serials, uuids, and labels, along with other
useful information.  I have a future number of enhancements in mind, but
it's a spare-time project.  I'm glad you like it, though.

You don't need the report for this incident, though.  Just stick it with your
backups.  And make a new one any time you change your setup.

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8HCnIACgkQBP+iHzflm3BN/gCfawVFbIvdeHhC9Z1BkTu6VcWu
7VMAn3SmwyK3WCdF0Fl+z1QNSCMrWu63
=sYlI
-----END PGP SIGNATURE-----
