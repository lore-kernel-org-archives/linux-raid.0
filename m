From: Alexander =?iso-8859-15?b?S/xobg==?= <alexander.kuehn@nagilum.de>
Subject: Re: [PATCH 9/9] mdadm: 'dump' support
Date: Tue, 30 Aug 2011 12:12:03 +0200
Message-ID: <20110830121203.Horde.wvD-Spk8pphOXLdzcMjKT1A@cakebox.homeunix.net>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
 <20110826021445.28015.63357.stgit@localhost6.localdomain6>
 <20110830125803.19ad660b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110830125803.19ad660b@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids


Zitat von NeilBrown <neilb@suse.de>:

> On Thu, 25 Aug 2011 19:14:45 -0700 Dan Williams <dan.j.williams@intel.com>
> wrote:
>
>>   mdadm -E /dev/sda --dump=foo
>>
>> Creates a sparse file image of /dev/sda named foo with a copy of the
>> metadata instance found by -E.
>>
>> When used in the opposite direction:
>>
>>   mdadm -E foo --dump=/dev/sda
>>
>> ...can restore metadata to a given block device, assuming it is
>> identical size to the dump file.
>
> Suppose we did have a separate 'restore' function - what would it look like?
> An option to create?
>
>   mdadm --create --restore=some-directory /dev/sda /dev/sdb
>

Yes, from a UI perspective having separate dump/restore options is  
better. Since there is also dump(8)/restore(8) it would also keep the  
nomenclature.
Otherwise I would rather name it "copy-metadata" or something as with  
copying the user is or should be aware that the order or arguments  
matters.
Alex.
