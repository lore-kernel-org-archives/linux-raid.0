From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 12:38:04 -0400
Message-ID: <18200.56684.14194.630264@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192810534.1666.68.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Doug" == Doug Ledford <dledford@redhat.com> writes:

Doug> On Fri, 2007-10-19 at 11:46 -0400, John Stoffel wrote:
>> >>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>> 
Justin> On Fri, 19 Oct 2007, John Stoffel wrote:
>> 
>> >> 
>> >> So,
>> >> 
>> >> Is it time to start thinking about deprecating the old 0.9, 1.0 and
>> >> 1.1 formats to just standardize on the 1.2 format?  What are the
>> >> issues surrounding this?

Doug> 1.0, 1.1, and 1.2 are the same format, just in different positions on
Doug> the disk.  Of the three, the 1.1 format is the safest to use since it
Doug> won't allow you to accidentally have some sort of metadata between the
Doug> beginning of the disk and the raid superblock (such as an lvm2
Doug> superblock), and hence whenever the raid array isn't up, you won't be
Doug> able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
Doug> case situations, I've seen lvm2 find a superblock on one RAID1 array
Doug> member when the RAID1 array was down, the system came up, you used the
Doug> system, the two copies of the raid array were made drastically
Doug> inconsistent, then at the next reboot, the situation that prevented the
Doug> RAID1 from starting was resolved, and it never know it failed to start
Doug> last time, and the two inconsistent members we put back into a clean
Doug> array).  So, deprecating any of these is not really helpful.  And you
Doug> need to keep the old 0.90 format around for back compatibility with
Doug> thousands of existing raid arrays.

This is a great case for making the 1.1 format be the default.  So
what are the advantages of the 1.0 and 1.2 formats then?  Or should be
we thinking about making two copies of the data on each RAID member,
one at the beginning and one at the end, for resiliency?  

I just hate seeing this in the mag page:

    Declare the style of superblock (raid metadata) to be used.
    The default is 0.90 for --create, and to guess for other operations.
    The default can be overridden by setting the metadata value for the
    CREATE keyword in mdadm.conf.

    Options are:

    0, 0.90, default

      Use the original 0.90 format superblock.  This format limits arrays to
      28 component devices and limits compo- nent devices of levels 1 and
      greater to 2 terabytes.

    1, 1.0, 1.1, 1.2

      Use the new version-1 format superblock.  This has few restrictions.
      The different sub-versions store the superblock at different locations
      on the device, either at the end (for 1.0), at the start (for 1.1) or
      4K from the start (for 1.2).


It looks to me that the 1.1, combined with the 1.0 should be what we
use, with the 1.2 format nuked.  Maybe call it 1.3?  *grin*

So at this point I'm not arguing to get rid of the 0.9 format, though
I think it should NOT be the default any more, we should be using the
1.1 combined with 1.0 format.

John
