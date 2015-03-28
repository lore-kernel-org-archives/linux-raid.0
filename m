From: Phil Turmel <philip@turmel.org>
Subject: Read-only mounts (was mdadm RAID6 "active" with spares and failed
 disks; need help)
Date: Sat, 28 Mar 2015 11:11:29 -0400
Message-ID: <5516C4A1.9030604@turmel.org>
References: <54ABEE54.6020707@sympatico.ca>	<BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl>	<BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl>	<54B305B2.6000702@lentijn.sess.ink>	<54B3F7ED.1000809@youngman.org.uk>	<BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl>	<54C0C73A.4080409@lentijn.sess.ink>	<BLU437-SMTP28725520E940DA3707A62F81090@phx.gbl>	<55160B0A.1090405@turmel.org> <20150328151142.11db8c9a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150328151142.11db8c9a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Matt Callaghan <matt_callaghan@sympatico.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/28/2015 06:11 AM, Roman Mamedov wrote:
> On Fri, 27 Mar 2015 21:59:38 -0400
> Phil Turmel <philip@turmel.org> wrote:
> 
>> I read through this.  Given all of the destructive actions you took, I
>> am doubtful you will ever get your data.  Like mounting "readonly".
>> That gives you a readonly filesystem, but it writes to the device.
>> Possibly a great deal if there's a journal to replay.
> 
> Are you sure, which FS does that? I remember some discussion on FS lists
> (Btrfs?), and IIRC the consensus and the implemented behavior was that the
> device shouldn't ever be touched with writes on RO mounts, no matter what.

I remember people being burned by it with ext3/4 a couple years ago.
Which is why all of the array disaster recoveries I've helped with
called for fsck -n to verify a reconstruction attempt, not a mount -o ro.

I will set up a small VM and see what recent kernels do.

Phil

