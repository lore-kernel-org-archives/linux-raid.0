From: linbloke <linbloke@fastmail.fm>
Subject: Re: [PATCH 0/9] recovering an imsm raid5 array
Date: Fri, 26 Aug 2011 21:06:22 +1000
Message-ID: <4E577E2E.2070903@fastmail.fm>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On 26/08/11 12:13 PM, Dan Williams wrote:

<snip>
> mistake in the recovery process.  Patch9 implements --dump support, the
> fact that something like this has not been implemented already is maybe
> a clue that it is not such a great idea?  I can imagine someone messing
> up their configuration if they restored a metadata image to the wrong
> device, but if you know what you are doing it could be a useful hack.
>

I'm just a nobody mdadm user but I read nearly every word of this list 
and read the above and thought, if Dan thinks it's a good idea, then it 
probably is. I then read the summary of Patch 9, included below and 
thought, this might be safer if it required a --force switch to actually 
make the change, force usually being a sign that the user knows what 
they are doing (;-) Perhaps without it, it could just check that foo is 
valid (identical size) and suggest the force switch to make it so. Sorry 
I'm not a coder that can supply a patch, this compromise to deliver the 
functionality but with a safeguard in place occurred to me.

Best regards and kudos to our linux developers.



   mdadm -E /dev/sda --dump=foo

Creates a sparse file image of /dev/sda named foo with a copy of the
metadata instance found by -E.

When used in the opposite direction:

   mdadm -E foo --dump=/dev/sda

...can restore metadata to a given block device, assuming it is
identical size to the dump file.




