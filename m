From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 11:24:46 -0700
Message-ID: <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F68CE0.2010906@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 27, 2009 at 9:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Goswin von Brederlow wrote:
>>
>> Or grub2 could be thought to install itself into all MBRs of all
>> drives in a raid set.
>>
>
> ... which is obviously completely wrong, given that that would break the
> whole RAID layer.
>
> The right thing is to use a RAID-1 partition.
>

...or use a metadata format that your platform bios understands and
provides an int 13h vector.  See the new external metadata formats
supported by the mdadm devel-3.0 branch.
