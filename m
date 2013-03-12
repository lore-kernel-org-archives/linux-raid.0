From: joystick <joystick@shiftmail.org>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Tue, 12 Mar 2013 12:12:46 +0100
Message-ID: <513F0DAE.4060801@shiftmail.org>
References: <wrfj1ubvi88x.fsf@redhat.com> <20130305080010.6285b435@notabene.brown> <wrfjlia2fd6h.fsf@redhat.com> <20130306131804.0b39752a@notabene.brown> <wrfj4ngog9h0.fsf@redhat.com> <20130312093231.72c54735@notabene.brown> <20130312123224.62018981@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130312123224.62018981@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/12/13 02:32, NeilBrown wrote:
> Subject: [PATCH] md/raid5: ensure sync and recovery don't happen at the same
>   time.

Watch out for probable mistake

