From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: write-refresh md array (feature request)
Date: Wed, 11 Sep 2013 13:00:15 -0700
Message-ID: <CAA9_cmfFSM8v-xEBHdVXuGXcRUcWa6qcHrdwjUqECSsKnY2t5Q@mail.gmail.com>
References: <20130910181905.GC21530@khazad-dum.debian.net>
	<CAGqmV7ph6JF1cVQwBt-FrzToThMC+gbfPMj3V5EFqbtoOFuFHQ@mail.gmail.com>
	<20130911123747.GB1736@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911123747.GB1736@khazad-dum.debian.net>
Sender: linux-raid-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 11, 2013 at 5:37 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 11 Sep 2013, CoolCold wrote:
>> You can achieve this with a bit inderect way - there are sync_min and
>> sync_max params which can be used to operate on certain borders of array,
>> more info
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/md.txt?id=refs/tags/v3.11#n579.
>
> Doesn't do anything close to what I requested.  Neither check nor repair
> will re-write sectors that appear to be good (and are actually returning the
> correct data after ECC correction by the component device, but will
> eventually fail if not rewritten to soon).

Sounds like a modification of the "replace" code to allow replacing
the with self-same drive. Something like "want_refresh" would mark the
drive as a soft replacement to mark that slot to be re-written.  But
if the drive is expected to be "weak" you could just rotate in a spare
drive without degrading the array with the existing code.
