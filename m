From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: deprecating /proc/mdstat
Date: Tue, 02 Feb 2016 09:33:31 -0500
Message-ID: <wrfjwpqnxjus.fsf@redhat.com>
References: <56A9102D.4030304@prgmr.com>
	<87twly1jc7.fsf@notabene.neil.brown.name>
	<20160128124121.Horde.YKtbZL0CUYKTuEkxLcmmhQ4@www3.nde.ag>
	<20160128182102.GA23378@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160128182102.GA23378@kernel.org> (Shaohua Li's message of
	"Thu, 28 Jan 2016 10:21:02 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "Jens-U. Mozdzen" <jmozdzen@nde.ag>, NeilBrown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaohua Li <shli@kernel.org> writes:
> On Thu, Jan 28, 2016 at 12:41:21PM +0100, Jens-U. Mozdzen wrote:
>> If there's to be a "new mdstat" in /sys, I'd be fine with that. That would
>> help migration for those "old scripts grep'ing /proc/mdstat" you rightfully
>> care about.
>> 
>> I suggest to include a file format version information on line 1
>> "/sys/.../mdstat", that way any client parsing such an interface could
>> verify the file format first, and bail out if it doesn't support the
>> currently presented format.
>
> All the info you can get from /proc/mdstat can be found in /sys/xxx. There
> isn't a central mdstat file in sysfs entry, each sysfs entry only export single
> type info. Version info is uncessary, if we need add new info, we'd just add a
> new sysfs entry.
>
> though the /proc/mdstat will not be deprecated soon, it's highly encouraged app
> switches to /sys. sysfs entry is easy to parse. And as Neil said, /proc/mdstat
> is hard to extend, so new info will likely only appear in sysfs.

I think the strong argument for /proc/mdstat is that it's easy for
visual inspection, but should not be scripted. I certainly use it quite
regularly, but maybe I am just old and lazy :)

Cheers,
Jes
