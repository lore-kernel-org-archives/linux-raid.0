From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 14:50:26 -0400
Message-ID: <24306.20210.265626.431196@quad.stoffel.home>
References: <rco1i8$1l34$1@ciao.gmane.io>
        <24305.24232.459249.386799@quad.stoffel.home>
        <875zbi3r46.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <875zbi3r46.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: John Stoffel <john@stoffel.org>, Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:

Nix> On 23 Jun 2020, John Stoffel told this:
>> You also don't say how *big* your disks will be, and if your 5 bay NAS
>> box can even split like that, and if it has the CPU to handle that.
>> Is it an NFS connection to the rest of your systems?

Nix> Side note: NFSv4 really is much much better at this stuff than v3
Nix> ever was. With a fast enough network connection, I find NFSv4 as
Nix> fast for more or less all workloads as NFSv3 was, mostly because
Nix> of the lease support in v4 allowing client-side caching of the
Nix> vast majority of files and directories that are either not
Nix> written to or only written to by one client in a given short time
Nix> window. (Obviously it also helps if your network is fast enough:
Nix> 1GbE is going to be saturated many times over by a RAID array of
Nix> any but the slowest modern HDDs. 10GbE and small 10GbE-capable
Nix> switches are not very costly these days and is definitely worth
Nix> investing in on the NFS server and any clients you care about.)

I've been thinking about moving to NFSv4 at home, since my main file
server has my main desktop as an NFS and LDAP client for
authentication.  Works quite well, and I don't care if my dekstop
reboots on my, since the homedir is elsewhere.

John
