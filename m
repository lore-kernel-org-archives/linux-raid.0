From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Sun, 2 Nov 2008 14:52:16 +0100
Message-ID: <20081102135216.GB21279@maude.comedia.it>
References: <dledford@redhat.com> <200810310102.m9V1236S025014@wind.enjellic.com> <18698.52568.828963.755364@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18698.52568.828963.755364@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 31, 2008 at 08:18:16PM +1100, Neil Brown wrote:
>On Thursday October 30, greg@enjellic.com wrote:
>> On Oct 27, 11:13am, Doug Ledford wrote:
>> } Subject: Re: RFC - device names and mdadm with some reference to udev.
>> 
>> Good evening to everyone, hope the week has gone well.
>> 
>> > > I would really like to have a clear separation of competencies.
>> > > Ideally, mdadm never creates any devices but leaves it all to udev,
>> > > and all configuration about alternate names ("symlinks") is done in
>> > > the udev rules file.
>> 
>> > This would then require that we have a working udev in our initrd
>> > images.  It would greatly increase the complexity of early booting
>> > as a result.
>> 
>> Whatever we do please do not make use of mdadm or startup of arrays
>> dependent on udev.  I do SAN's for a living and have had far too many
>> phone calls and have spent too much time trying to get boxes messed up
>> by udev back on the fabric to want to add any more complication to the
>> mix.

+1

>I had intended to continue to support the no-udev installations, but
>thank you the encouragement that it really is needed and will be used.
>
>Just a clarification:  are you envisaging an installation without udev
>at all, or one with udev installed and active, but you don't wont
>mdadm to depend on it?  That latter option may be more awkward (I
>currently support an environment variable which says "just create the
>devices, even if udev appears to be installed").

i have no objections in letting udev create my device files.
what i dislike is when udev sees a device appearing, and decides it
knows better than me, so it starts using it right away, no matter if it
is an usb key or a multi-tb shared storage.
I could never have tought of something so stupid as the incremental
assembly of md arrays,
0 advantages gained for lot of trouble.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
