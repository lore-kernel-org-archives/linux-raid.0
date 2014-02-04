From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 4 Feb 2014 08:29:02 -0700
Message-ID: <382956C2-F541-4AAE-9997-AEB0B2C55524@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52EECD53.30802@turmel.org> <52F0A79F.7090707@gmail.com> <52F0A976.9080306@hesbynett.no> <BEFF038F-20FE-4F52-A9BA-FB2F8A030997@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BEFF038F-20FE-4F52-A9BA-FB2F8A030997@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 4, 2014, at 8:13 AM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> This mdadm warning "possible for there to be confusion about whether the superblock applies to a whole device or just the last partition" would only apply if you attempt to make whole physical drives md member devices, which then runs into GPT problems.

And that warning applies to the older 0.90 metadata.

Chris Murphy