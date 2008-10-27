From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 17:13:44 +0100
Message-ID: <ac3eb2510810270913y3201daa7jddb35a42b942bf3f@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <1225120416.4845.128.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225120416.4845.128.camel@firewall.xsintricity.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 16:13, Doug Ledford <dledford@redhat.com> wrote:
> On Mon, 2008-10-27 at 09:22 +0100, martin f krafft wrote:
>> also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:

>> > I'm also wondering if I should include a udev 'rules' file for md
>> > in the mdadm distribution.  Obviously it would be no more than
>> > a recommendation, but it might give me a voice in guiding how udev
>> > interacted with mdadm.
>>
>> I would really like to have a clear separation of competencies.
>> Ideally, mdadm never creates any devices but leaves it all to udev,
>> and all configuration about alternate names ("symlinks") is done in
>> the udev rules file.
>
> This would then require that we have a working udev in our initrd
> images.  It would greatly increase the complexity of early booting as a
> result.

There is no usual distro not having udev there.

Kay
