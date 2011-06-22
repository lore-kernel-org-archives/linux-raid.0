From: Phil Turmel <philip@turmel.org>
Subject: Re: reaid problem at reboot
Date: Tue, 21 Jun 2011 21:34:46 -0400
Message-ID: <4E0146B6.40101@turmel.org>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org> <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>,<4E0113FE.503@turmel.org> <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: william L'Heureux <wil_c_will@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi William,

On 06/21/2011 09:00 PM, william L'Heureux wrote:
> 
> for x in /dev/sd[abcdefghijkm] ; do echo "**** $x ****" ; dd if=$x skip=2056 count=2 2>/dev/null |strings ; done
> **** /dev/sda ****
> -BILLSSHACK:0
> /4o.
> **** /dev/sdb ****
> billsshack:3
> **** /dev/sdc ****
> -BILLSSHACK:0
> **** /dev/sdd ****
> -BILLSSHACK:0
> CgW:
> **** /dev/sde ****
> billsshack:3
> **** /dev/sdf ****
> billsshack:3
> **** /dev/sdg ****
> billsshack:3
> <:      L
> **** /dev/sdh ****
> -BILLSSHACK:0
> **** /dev/sdi ****
> -BILLSSHACK:0
> **** /dev/sdj ****
> -BILLSSHACK:0
> **** /dev/sdk ****
> billsshack:3
> **** /dev/sdm ****
> billsshack:3
> Zm$8  2

Hmmm.  Not what I expected.  Ah!  Missing "1".  Try both of these instead:

for x in /dev/sd[abcdefghijkm]1 ; do echo "**** $x ****" ; dd if=$x skip=2056 count=2 2>/dev/null |strings ; done

for x in /dev/sd[abcdefghijkm]1 ; do echo "**** $x ****" ; dd if=$x skip=2048 count=1 2>/dev/null |hexdump -C ; done

Phil
