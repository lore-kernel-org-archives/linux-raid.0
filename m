From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Wed, 16 Dec 2015 23:57:43 -0600
Message-ID: <CAE9DZUTrujvP4AzaHgdtHRUKqR8pF81+6tCB7WiB6GNuU9C-0Q@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
	<CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
	<22122.64143.522908.45940@quad.stoffel.home>
	<CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
	<22123.9525.433754.283927@quad.stoffel.home>
	<CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
	<CAE9DZUTTP1VhVgT56dyv6aLaM2V8peWSHaBg4xvXzGGUZcJ_hw@mail.gmail.com>
	<CAE9DZURuPGEL4bG=44ntbjp+51jktn36LFGfn11xFR-X9O9POw@mail.gmail.com>
	<566B6C8F.7020201@turmel.org>
	<CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
	<566BA6E5.6030008@turmel.org>
	<CAE9DZUT42rCgjSacbs170ftzBtC4i83TRvk7CGeELqpYg3hVzw@mail.gmail.com>
	<CAK2H+edazVORrVovWDeTA8DmqUL+5HRH-AcRwg8KkMas=o+Cog@mail.gmail.com>
	<CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
	<CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
	<22128.11867.847781.946791@quad.stoffel.home>
	<CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
	<22128.35881.182823.556362@quad.stoffel.home>
	<CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
	<CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
	<CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 16, 2015 at 6:24 PM, Mark Knecht <markknecht@gmail.com> wrote:
>
>
> On Wed, Dec 16, 2015 at 7:31 AM, Dallas Clement <dallas.a.clement@gmail.com>
> wrote:
>>
>> Phil, the 16k chunk size has really given a boost to my RAID 5
>> sequential write performance measured with fio, bs=1408k.
>>
>> This is what I was getting with a 128k chunk size:
>>
>> iodepth=4 => 605 MB/s
>> iodepth=8 => 589 MB/s
>> iodepth=16 => 634 MB/s
>> iodepth=32 => 635 MB/s
>>
>> But this is what I'm getting with a 16k chunk size:
>>
>> iodepth=4 => 825 MB/s
>> iodepth=8 => 810 MB/s
>> iodepth=16 => 851 MB/s
>> iodepth=32 => 866 MB/s
>
>
> Dallas,
>    Hi. Just for kicks I tried Phil's idea (I think it was Phil) and sampled
> stripe_cache_active
> by putting this command in a 1 second loop and running it today while I
> worked.
>
> cat  /sys/block/md3/md/stripe_cache_active >> testCacheResults
>
> My workload is _very_ different from what you're working on. This is a
> high-end desktop
> machine (Intel 980i Extreme processor, 24GB DRAM, RAID6) running 2 Windows 7
> VMs
> while I watch the stock market and program in MatLab. None the less I was
> somewhat
> surprise at the spread in the number of active lines. The test ran for about
> 10 hours with
> about 94% of the results being 0, but numbers ranging from 1 line to 2098
> lines active
> at a single time. Also interesting to me was when that 2098 value hit it was
> apparently
> all clear in less than 1 second as the values immediately following where
> back to 0.
>
>    Note that this is 5 disk RAID6 set up with a chunk size of 16k and an
> internal
> intent bitmap. I did no work like you're doing when I set the machine up. I
> just picked
> some numbers and built it so that I could get to work.
>
>    I've not done any real speed testing but a quick run of dd suggested
> maybe
> 160MB/S-180MB/S which sounds about right to me.
>
>    Anyway, just thought it was interesting.
>
> - Mark
>
> mark@c2RAID6 ~ $ sort -g testCacheResults | uniq -c
>   33316 0
>     127 1
>      98 2
>     105 3
>     141 4
>      71 5
>      48 6
>      38 7
>      39 8
>      36 9
>      31 10
>      23 11
>      30 12
>      26 13
>      17 14
>      12 15
>      20 16
>      14 17
>      17 18
>      23 19
>      19 20
>      12 21
>      13 22
>      14 23
>      16 24
>      15 25
>      14 26
>       8 27
>      11 28
>      16 29
>      10 30
>       3 31
>       9 32
>       3 33
>       5 34
>      13 35
>       7 36
>       7 37
>       3 38
>       7 39
>       6 40
>       9 41
>       5 42
>       6 43
>       7 44
>      12 45
>       7 46
>       7 47
>       6 48
>       6 49
>       5 50
>       4 51
>       8 52
>       2 53
>       6 54
>      10 55
>       3 56
>       7 57
>       7 58
>       9 59
>       3 60
>       5 61
>       8 62
>       1 63
>       5 64
>       4 65
>       9 66
>       3 67
>       3 68
>       2 69
>       2 70
>       5 71
>       2 72
>       3 73
>       3 74
>       3 75
>       3 76
>       3 77
>       1 78
>       4 79
>       1 80
>       3 81
>       2 82
>       1 83
>       4 84
>       1 85
>       4 86
>       1 87
>       2 89
>       2 90
>       1 91
>       2 92
>       1 93
>       4 94
>       2 95
>       5 96
>       2 97
>       2 98
>       2 99
>       5 100
>       2 101
>       1 102
>       6 103
>       5 104
>       1 105
>       3 106
>       3 107
>       2 108
>       3 109
>       3 110
>       4 111
>       3 112
>       1 113
>       4 114
>       1 115
>       1 116
>       1 117
>       3 118
>       4 119
>       3 120
>       3 121
>       2 122
>       3 123
>       4 124
>       2 125
>       3 126
>       1 127
>       2 128
>       2 129
>       1 130
>       3 131
>       2 132
>       2 133
>       2 134
>       3 135
>       1 136
>       2 137
>       3 138
>       5 140
>       3 141
>       3 142
>       1 143
>       1 144
>       5 145
>       1 146
>       6 147
>       3 148
>       1 149
>       1 150
>       1 152
>       2 153
>       1 154
>       1 155
>       1 156
>       4 157
>       3 158
>       1 159
>       3 160
>       1 161
>       6 162
>       1 163
>       2 164
>       1 165
>       1 166
>       4 167
>       2 168
>       5 169
>       2 170
>       3 172
>       5 173
>       4 174
>       4 175
>       4 176
>       3 177
>       2 178
>       2 179
>       6 180
>       2 181
>       3 182
>       3 184
>       2 185
>       3 186
>       4 187
>       2 188
>       5 190
>       4 192
>       3 193
>       2 194
>       6 196
>       1 197
>       1 198
>       1 199
>       2 200
>       4 201
>       2 203
>       2 204
>       4 206
>       1 207
>       2 208
>       5 209
>       2 210
>       3 211
>       6 212
>       3 213
>       3 214
>       4 215
>       4 216
>       6 217
>       8 218
>       1 219
>       5 220
>       6 221
>       4 222
>       6 223
>       6 224
>       5 225
>       2 226
>       3 227
>       5 228
>       2 229
>       1 230
>       5 231
>       6 232
>       6 233
>       3 234
>       4 235
>       6 236
>       5 237
>       1 238
>       5 239
>       2 240
>       5 241
>       4 242
>       2 244
>       2 245
>       2 246
>       2 247
>       3 248
>       2 249
>       4 250
>       3 251
>       6 252
>       2 253
>       2 254
>       5 255
>       3 256
>       4 257
>       3 258
>       3 259
>       6 260
>       2 261
>       3 262
>       3 263
>       1 264
>       3 265
>       1 266
>       4 267
>       4 268
>       4 269
>       3 270
>       4 271
>       2 272
>       1 273
>       1 275
>       1 276
>       5 277
>       6 278
>       2 279
>       2 280
>       1 281
>       6 282
>       5 283
>       8 284
>       1 285
>       5 286
>       4 287
>       2 288
>       2 289
>       3 290
>       2 291
>       1 292
>       2 293
>       1 294
>       3 295
>       2 296
>       2 297
>       1 298
>       3 299
>       2 300
>       1 301
>       2 303
>       3 305
>       3 306
>       1 307
>       1 308
>       2 309
>       2 310
>       1 311
>       1 312
>       1 313
>       2 314
>       1 315
>       1 317
>       1 318
>       2 320
>       1 321
>       2 322
>       2 323
>       2 324
>       1 325
>       1 326
>       2 327
>       3 328
>       2 329
>       1 331
>       1 335
>       1 336
>       2 337
>       1 338
>       1 339
>       1 340
>       3 341
>       1 343
>       1 344
>       1 346
>       1 347
>       1 348
>       2 349
>       1 350
>       1 352
>       2 353
>       1 357
>       1 359
>       1 360
>       1 365
>       1 368
>       1 369
>       2 372
>       2 373
>       1 378
>       1 380
>       1 388
>       2 392
>       1 409
>       1 410
>       1 414
>       1 425
>       1 444
>       1 455
>       2 460
>       1 465
>       1 469
>       1 484
>       1 485
>       1 492
>       1 499
>       1 503
>       1 504
>       1 509
>       1 518
>       1 534
>       1 540
>       1 541
>       1 543
>       1 546
>       1 572
>       1 575
>       1 586
>       1 591
>       1 592
>       1 602
>       1 637
>       1 661
>       1 674
>       1 732
>       1 770
>       1 780
>       1 905
>       2 927
>       1 928
>       1 1036
>       1 1146
>       1 1151
>       1 1157
>       1 1314
>       1 1974
>       1 2098
> mark@c2RAID6 ~ $

Hi Mark.  This is quite fascinating.  Now I really want to try it with
my workloads.  How big is your stripe cache btw?
