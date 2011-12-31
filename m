From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: RAID0 partition set to spare
Date: Sat, 31 Dec 2011 11:08:42 +0100
Message-ID: <4EFEDF2A.5060408@redhat.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>	<4EFD9956.5050703@redhat.com> <CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Carlson <stevengcarlson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/31/11 04:03, Steve Carlson wrote:
> Hi Jes,
> 
> The system has mostly been sitting powered down while I'm not trying
> to fix it.  Both drives reporting 37c temps right now.
> 
> mdadm --stop /dev/md2 && dmesg -c && mdadm --assemble /dev/md2 /dev/sd[ab]3
> http://dl.dropbox.com/u/2776371/raid/mdadm_stop_dmesg_c_mdadm_assemble.txt

Hi Steve,

What I meant here is that I would like to see the dmesg output at this
point, to see if there were any read errors reported during the assembly.

> I also ran extended self tests just to be thorough, and they both came
> back error free.  I'm unsure as to whether that puts them in the clear
> for bad sectors though.

There were read errors in the dmesg output you posted earlier, which is
why I am wary of it.

Cheers,
Jes
